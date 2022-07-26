module sprite_generator
	#(		
		parameter sprite_width = 36, 		// largeur du sprite en pixels
		parameter sprite_height = 54, 	// hauteur du sprite en pixels
		parameter screen_width = 640,		// largeur de l'écran en pixels
		parameter screen_height = 480		// hauteur de l'écran en pixels
	)

	(
		input clk25, rst, frame, inDisplayArea,
		input wire [9:0] x, y,
		input wire [2:0] color_pixel_sprite,
		output reg r, g, b,
		output wire [11:0] adr_sprite
	);
	
	
	reg [5:0] counter_frame = 0; // compteur de frames entre 0 et 63
	wire inSprite;
	integer x_sprite = (screen_width - sprite_width) / 2;
	integer y_sprite = (screen_height - sprite_height) / 2;
	
	integer dir_x_sprite = 1, dir_y_sprite = 1; // déplacement en diagonale vers le bas à droite de l'écran	
	
	// inSprite=1 si le pixel (x, y) en cours de balayage est à l'intérieur du sprite, inSprite=0 sinon
	assign inSprite = (x >= x_sprite) && (x < x_sprite + sprite_width)
							&&
							(y >= y_sprite) && (y < y_sprite + sprite_height);
							
	// calcul de l'adresse en ROM
	assign adr_sprite = (y - y_sprite) * sprite_width + (x - x_sprite) 
									+ ((counter_frame >= 31) ? sprite_width * sprite_height : 0); // décalage de l'adresse

	
	always @(posedge clk25 or negedge rst)
	begin
		if (rst==0) begin	// Réinitialisation si appui sur bouton Reset
			x_sprite <= (screen_width - sprite_width) /2;
			y_sprite <= (screen_height - sprite_height) / 2;
			dir_x_sprite <= 1;
			dir_y_sprite <= 1;
		end else
		begin
			if (frame) begin // calcul de la position du sprite en dehors de la zone d'affichage active	
				counter_frame <= counter_frame + 1;
				x_sprite <= x_sprite + dir_x_sprite;
				y_sprite <= y_sprite + dir_y_sprite;
			
				if (x_sprite > screen_width - sprite_width) begin	// rebond sur bord droit
					dir_x_sprite <= dir_x_sprite * (-1);
					x_sprite <= screen_width - sprite_width;
				end
				else if (x_sprite < 0) begin				// rebond sur bord gauche
					dir_x_sprite <= dir_x_sprite * (-1);
					x_sprite <= 0;
				end
				
				if (y_sprite > screen_height - sprite_height) begin	// rebond sur bord bas
					dir_y_sprite <= dir_y_sprite * (-1);
					y_sprite <= screen_height - sprite_height;				
				end
				else if (y_sprite < 0) begin				// rebond sur bord haut
					dir_y_sprite <= dir_y_sprite * (-1);
					y_sprite <= 0;
				end
			end 
			else
			begin
				x_sprite <= x_sprite;
				y_sprite <= y_sprite;			
			end
					
		end
	end

	
	always @(*)
		begin
			if (inDisplayArea) // si coordonnées dans l'aire d'affichage
			begin			
				if (inSprite) // si coordonnées dans l'aire d'affichage du sprite
				begin
					r <= color_pixel_sprite[2];
					g <= color_pixel_sprite[1];
					b <= color_pixel_sprite[0];
				
				end else
				begin
					r <= 1'b0;
					g <= 1'b0;
					b <= 1'b0;				
				end									
			end
			else
			begin
				r <= 1'b0;
				g <= 1'b0;
				b <= 1'b0;
			end
		end

endmodule
