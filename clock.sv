module clock(
	input			reset_n,		//reset pin
	input			clk_1sec,		//1 sec clock
	input			clk_1ms,		//1 mili sec clock
	input			mil_time,		//mil time pin
	output reg [6:0]	segment_data,		//output 7 seg data
	output reg [2:0]	digit_select		//digit select
);


//internal registers
reg [2:0] cnt;	//current digit to display to
reg [3:0] dig;	//current value to display
reg [6:0] d;	//7-segment rep. of digit
reg [5:0] sec;	//current seconds
reg [5:0] min;	//current minutes
reg [4:0] hour;	//current hour 24h

logic min_t;	//signal to increment minutes
logic hour_t;	//signal to increment hours


//assignments
assign segment_data = d;
assign digit_select = cnt;



//display counter and 7-seg lookup
always_comb begin
	unique case(cnt)		//calculate dig
	  0:	dig = (min)%(10);
	  1:	dig = (min)/(10);
	  2:	dig = (hour)%(10);
	  3:	dig = (hour)/(10);
	endcase


	unique case(dig)		//send correct 7-seg display
	  1:	d = 7'b1111001;
	  2:	d = 7'b0100100;
	  3:	d = 7'b0110000;
	  4:	d = 7'b0011001;
	  5:	d = 7'b0010010;
	  6:	d = 7'b0000010;
	  7:	d = 7'b1111000;
	  8:	d = 7'b0000000;
	  9:	d = 7'b0010000;
	  0:	d = 7'b1000000;
	endcase

end


//change digit to display to at every ms
always_ff @( posedge clk_1ms ) begin
	if(cnt == 3)	cnt <= 0;
	else		cnt <= cnt + 1;
end



//count seconds
always_ff @( posedge clk_1sec, negedge reset_n ) begin
	if(!reset_n) begin
	  sec <= 0;
	  min <= 0;
	  hour <= 0;
	end
	else begin
	  if(sec == 59) begin
	    sec <= 0;
	    min_t <= 1;		//signal to count 1 minute
	  end
	  else begin
	    sec <= sec + 1;
	    min_t <= 0;		//bring min_t back low
	  end
	end
end


//count minutes
always_ff @( posedge min_t ) begin
	if(min == 59) begin
	  min <= 0;
	  hour_t <= 1;		//signal to count 1 hour
	end
	else begin
	  min <= min + 1;
	  hour_t <= 0;
	end
end


//count hours
always_ff @( posedge hour_t ) begin
	if(hour == 23) begin
	  hour <= 0;
	end
	else begin
	  hour <= hour + 1;
	end
end


endmodule
