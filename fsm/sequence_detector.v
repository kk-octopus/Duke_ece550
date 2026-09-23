module sequence_detector(seq_in, reset, clk, detect, cur_state);
    input seq_in;
    input reset;
    input clk;
    output detect;
    output reg[2:0]cur_state;
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
    reg [2:0] state, next_state;
    reg out_para;

    always @(*) begin
        case(state)
            A: begin
                if(seq_in == 1)
                next_state = B;
                else
                next_state = A;
                
            end

            B: begin
                if(seq_in == 1)
                next_state = C;
                else
                next_state = A;
            end

            C: begin
                if(seq_in == 0)
                next_state = D;
                else
                next_state = C;
            end

            D: begin
                if(seq_in == 1)
                next_state = E;
                else
                next_state = A;
            end

            E: begin
                if(seq_in == 1)
                next_state = C;
                else
                next_state = A;
            end

            default:
                next_state = A;
        endcase
        
        cur_state = state;

        if(state == E)
        out_para = 1'b1;
        else
        out_para = 1'b0;
        
    end
    assign detect = out_para;

    always @(posedge clk) begin
        if(reset == 1)
        state <= A;
        else
        state <= next_state;
    end
endmodule