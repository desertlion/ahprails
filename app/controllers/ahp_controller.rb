class AhpController < ApplicationController
    # listing tabel untuk perhitungan kriteria
    def criteria
        # Ambil seluruh kriteria dari tabel criteria melalui model Criterium
        @criteria = Criterium.includes(:subcriteria).all
        # Ambil nilai jumlah kriteria dikurangi satu dikarenakan index array dimulai dari 0
        @jumlah   = @criteria.length-1
    end
    # hitung AHP
    def calculate
        # ambil seluruh kriteria
        @Criteria    = Criterium.includes(:subcriteria).all
        # ambil jumlah kriteria dikurangi 1
        @jlhkriteria = @Criteria.length-1
        # buat array baru
        @criteria    = Array.new(@jlhkriteria+1) { Array.new(@jlhkriteria+1) }
        @sum         = {};
        @sumpv       = {};
        @sqrt3       = {}; # akar pangkat 3
        @bobot       = {};

        for baris in 0..@jlhkriteria
            @sqrt3[baris] = 1 if @sqrt3[baris] == nil;
            for kolom in 0..@jlhkriteria
                if baris == kolom
                    @criteria[baris][kolom] = 1
                elsif baris < kolom
                    @criteria[baris][kolom] = params[:criteria][baris.to_s][kolom.to_s].to_i
                else
                    @criteria[baris][kolom] = 1/params[:criteria][kolom.to_s][baris.to_s].to_f
                end
                @sum[kolom]   = @sum[kolom].to_f + @criteria[baris][kolom].to_f;
                @sqrt3[baris] = @sqrt3[baris].to_f * @criteria[baris][kolom]
                if kolom == @jlhkriteria then @sqrt3[baris] = @sqrt3[baris]**(1.to_f/(@jlhkriteria+1).to_f).to_f end
                # if kolom == 2 then render json: (1.to_f/(@jlhkriteria+1).to_f).to_f and return end
            end
        end
        # hitung bobot
        @sumSqrt3 = 0.0
        @sqrt3.length.times { |i| @sumSqrt3 = (@sumSqrt3.to_f + @sqrt3[i].to_f).to_f }
        @lambda   = 0.0
        for i in 0..@jlhkriteria
            @bobot[i] = (@sqrt3[i].to_f/@sumSqrt3.to_f)
            data = Criterium.find(@Criteria[i].id)
            data.ahp = @bobot[i]
            data.save
            @sumpv[i] = (@sum[i]*@bobot[i])
            @lambda   = (@lambda + @sumpv[i])
        end
        @ci = (@lambda - (@jlhkriteria+1)) / @jlhkriteria
        ir  = [0, 0, 0.58, 5.9, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49, 1.51, 1.48, 1.56, 1.57, 1.59];
        @cr = @ci / ir[@jlhkriteria];

        # Hitung subcriteria
        # buat array baru
        @subcriteria    = {};
        
        # Mulai Hitung AHP untuk setiap sub kriteria
        # Khusus topografi tidak memiliki sub, jadi tidak dihitung
        @Criteria.each do |kriteria|
            # Jangan hitung kriteria yang tidak memiliki sub
            sub         = kriteria.subcriteria
            panjangsub  = kriteria.subcriteria.length
            if panjangsub < 1 then return end
            # Mulai Hitung AHP untuk setiap Sub
            # Simpan semua data AHP sub khusus id ini ke dalam variabel @subcriteria
            @subcriteria[kriteria.id] = {}
            @subcriteria[kriteria.id][:subsum] = {}
            @subcriteria[kriteria.id][:subsumpv] = {}
            @subcriteria[kriteria.id][:subsqrt3] = {}
            @subcriteria[kriteria.id][:subbobot] = {}
            @subcriteria[kriteria.id][:nilai]    = {}
            sub.each_with_index do |baris, index|
                # Jika akar pangkat 3 sub kosong, ubah jadi 1
                @subcriteria[kriteria.id][:subsqrt3][index] = 1 if @subcriteria[kriteria.id][:subsqrt3][index] == nil;
                sub.each_with_index do |kolom, idx|
                    # Hitung nilai2 matrix nya berdasarkan input
                    if index == idx
                        @subcriteria[kriteria.id][:nilai]["#{index}#{idx}"] = 1
                    elsif index < idx
                        @subcriteria[kriteria.id][:nilai]["#{index}#{idx}"] = params[:subcriteria][baris.id.to_s][kolom.id.to_s].to_f
                    else
                        @subcriteria[kriteria.id][:nilai]["#{index}#{idx}"] = 1/params[:subcriteria][kolom.id.to_s][baris.id.to_s].to_f
                    end
                    # Jumlahkan 1 kolom menurun
                    @subcriteria[kriteria.id][:subsum][idx] = @subcriteria[kriteria.id][:subsum][idx].to_f + @subcriteria[kriteria.id][:nilai]["#{index}#{idx}"].to_f;
                    # Hitung produknya kemudian ambil akar pangkat 3 nya
                    @subcriteria[kriteria.id][:subsqrt3][index] = @subcriteria[kriteria.id][:subsqrt3][index].to_f * @subcriteria[kriteria.id][:nilai]["#{index}#{idx}"].to_f
                    if idx == sub.length-1 then 
                        @subcriteria[kriteria.id][:subsqrt3][index] = @subcriteria[kriteria.id][:subsqrt3][index]**(1.to_f/(sub.length).to_f).to_f 
                    end
                    # Jumlahkan secara menurun hasil dari sqrt
                end
            end
            # hitung bobot per sub kriteria
            @subcriteria[kriteria.id][:subsumSqrt3] = 0.0
            sub.length.times { |i| @subcriteria[kriteria.id][:subsumSqrt3] = (@subcriteria[kriteria.id][:subsumSqrt3] + @subcriteria[kriteria.id][:subsqrt3][i].to_f).to_f }
            @subcriteria[kriteria.id][:sublambda]   = 0.0
            @subcriteria[kriteria.id][:subsumbobot]   = 0.0
            for i in 0..sub.length-1
                @subcriteria[kriteria.id][:subbobot][i] = (@subcriteria[kriteria.id][:subsqrt3][i].to_f/@subcriteria[kriteria.id][:subsumSqrt3].to_f)
                @subcriteria[kriteria.id][:subsumbobot] = (@subcriteria[kriteria.id][:subsumbobot] + @subcriteria[kriteria.id][:subbobot][i].to_f).to_f
                data = Subcriterium.find(sub[i].id)
                data.ahp = @subcriteria[kriteria.id][:subbobot][i]
                data.save
                @subcriteria[kriteria.id][:subsumpv][i]    = (@subcriteria[kriteria.id][:subsum][i]*@subcriteria[kriteria.id][:subbobot][i])
                @subcriteria[kriteria.id][:sublambda]   = (@subcriteria[kriteria.id][:sublambda] + @subcriteria[kriteria.id][:subsumpv][i])
            end
#            @ci = (@lambda - (@jlhkriteria+1)) / @jlhkriteria
#            ir  = [0, 0, 0.58, 5.9, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49, 1.51, 1.48, 1.56, 1.57, 1.59];
#            @cr = @ci / ir[@jlhkriteria];
        end
    end
end
