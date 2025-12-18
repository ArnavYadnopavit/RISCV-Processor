

    
   /* 
    always@(posedge clk or posedge reset)begin
        if(reset)begin
        Divfsm<=4'b0000;
        Divreset<=1'b1;
        end
        else begin
        casez(Divfsm)
            4'b0000:begin
                    if(isDiv)begin
                            Divfsm<=4'b0001;
                            Divreset<=1'b1;
                        end
                    else begin
                            Divfsm<=4'b0000;
                        end
                   end
            4'b0001: begin
        Divfsm   <= 4'b0010;
        Divreset <= 1'b0;
    end
    4'b0010: begin
        Divfsm   <= 4'b0011;
        Divreset <= 1'b0;
    end
    4'b0011: begin
        Divfsm   <= 4'b0100;
        Divreset <= 1'b0;
    end
    4'b0100: begin
        Divfsm   <= 4'b0101;
        Divreset <= 1'b0;
    end
    4'b0101: begin
        Divfsm   <= 4'b0110;
        Divreset <= 1'b0;
    end
    4'b0110: begin
        Divfsm   <= 4'b0111;
        Divreset <= 1'b0;
    end
    4'b0111: begin
        Divfsm   <= 4'b1000;
        Divreset <= 1'b0;
    end
    4'b1000: begin
        Divfsm   <= 4'b1001;
        Divreset <= 1'b0;
    end
    4'b1001: begin
        Divfsm   <= 4'b1010;
        Divreset <= 1'b0;
    end
    4'b1010: begin
        Divfsm   <= 4'b0000;   // return to idle/start
        Divreset <= 1'b1;
    end
    default: begin
        Divfsm   <= 4'b0000;
        Divreset <= 1'b1;
    end
        endcase
        end
    end
    
    */
