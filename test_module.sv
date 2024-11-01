module test_module #(parameter DATA_W = 8)(
    input logic clk_in,
    input logic reset_in,
    input logic [(DATA_W - 1) : 0] data_in,

    output logic [(DATA_W - 1) : 0] out_0, 
    output logic out_valid_0, 
    output logic [(DATA_W - 1) : 0] out_1, 
    output logic out_valid_1, 
    output logic [(DATA_W - 1) : 0] out_2, 
    output logic out_valid_2, 
    output logic [(DATA_W - 1) : 0] out_3, 
    output logic out_valid_3
);

    reg [(DATA_W - 1) : 0] buffer[3:0];
    logic [3:0] buffer_valid;
    
    always @(posedge clk_in) begin
        // Обработка сброса
        if (reset_in) begin
            buffer[0] <= 0;
            buffer[1] <= 0;
            buffer[2] <= 0;
            buffer[3] <= 0;
            buffer_valid <= 0;
            
            out_0 <= 0;
            out_valid_0 <= 0;
            out_1 <= 0;
            out_valid_1 <= 0;
            out_2 <= 0;
            out_valid_2 <= 0;
            out_3 <= 0;
            out_valid_3 <= 0;
        end
        else begin
            // Проверка дублирования числа
            logic duplicate = 0;
            for (int i = 0; i < 4; i++) begin
                if (buffer[i] == data_in)
                    duplicate = 1;
            end
            
            // Обновление буфера
            if (!duplicate) begin
                for (int i = 3; i > 0; i--) begin
                    buffer[i] <= buffer[i-1];
                end
                buffer[0] <= data_in;
                
                // Обновление сигналов валидности
                buffer_valid[3] <= 1;
                for (int i = 2; i >= 0; i--) begin
                    buffer_valid[i] <= buffer_valid[i+1];
                end
            end
            
            // Выбор и вывод результатов
            case (buffer_valid)
                4'b1111: out_0 <= buffer[0];
                      out_valid_0 <= 1;
                4'b1110: out_1 <= buffer[1];
                      out_valid_1 <= 1;
                4'b1100: out_2 <= buffer[2];
                      out_valid_2 <= 1;
                4'b1000: out_3 <= buffer[3];
                      out_valid_3 <= 1;
                default: out_0 <= 0;
                         out_valid_0 <= 0;
                         out_1 <= 0;
                         out_valid_1 <= 0;
                         out_2 <= 0;
                         out_valid_2 <= 0;
                         out_3 <= 0;
                         out_valid_3 <= 0;
            endcase
        end
    end

endmodule
