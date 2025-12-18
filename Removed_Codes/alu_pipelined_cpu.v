    /*
    6'b0_1?000:begin //beq
        out=64'b0;
        valid=1'b0;
        branchAlu=(a==b)?1'b1:1'b0;            
    end
    6'b0_1?001:begin //bne
        out=64'b0;
        valid=1'b0;
        branchAlu=(a!=b)?1'b1:1'b0;            
    end
    6'b0_1?100:begin //blt
        out=64'b0;
        valid=1'b0;
        branchAlu=($signed(a)<$signed(b))?1'b1:1'b0;            
    end
    6'b0_1?101:begin //bge
        out=64'b0;
        valid=1'b0;
        branchAlu=($signed(a)>=$signed(b))?1'b1:1'b0;            
    end
    6'b0_1?110:begin //bltu
        out=64'b0;
        valid=1'b0;
        branchAlu=(a<b)?1'b1:1'b0;            
    end
    6'b0_1?111:begin //bgeu
        out=64'b0;
        valid=1'b0;
        branchAlu=(a>=b)?1'b1:1'b0;            
    end
    */
