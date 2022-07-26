module vga_sync
	#(		
		parameter hpixels = 800, 	// nombre de pixels par ligne
		parameter vlines = 525, 	// nombre de lignes image
		parameter hpulse = 96, 		// largeur d'impulsion du signal HSYNC
		parameter vpulse = 2, 		// largeur d'impulsion du signal VSYNC
		parameter hbp = 48, 			// horizontal back porch
		parameter hfp = 16, 			// horizontal front porch
		parameter vbp = 33, 			// vertical back porch
		parameter vfp = 10			// vertical front porch		
	)
	
	(
		input clk25, rst,			// signal horloge 25MHz, signal reset 
		output wire [9:0] x, y,	// coordonnées écran pixel en cours
		output inDisplayArea, 	//	inDisplayArea = 1 si le pixel en cours est dans la zone d'affichage, = 0 sinon
		output hsync, vsync,		// signaux de synchronisation horizontal et vertical
		output frame				// impulsion en début de phase inactive
	);
	
	
	// compteurs 10 bits horizontal et vertical
	// counterX : compteur de pixels sur une ligne
	// counterY : compteur de lignes
	reg[9:0] counterX, counterY;
	
	
	always @(posedge clk25 or negedge rst) // sur front montant de l'horloge 25MHz, ou front descendant du signal Reset
	begin
		if (rst == 0) begin // Remise à zéro des compteurs sur Reset
			counterX <= 0;
			counterY <= 0;	
		end else
		begin
			// compter les pixels jusqu'en bout de ligne
			if (counterX < hpixels - 1)
				counterX <= counterX + 1;
			else
			// En fin de ligne, remettre le compteur de pixels à zéro,
			// et incrémenter le compteur de lignes.
			// Quand toutes les lignes ont été balayées,
			// remettre le compteur de lignes à zéro.
			begin
				counterX <= 0;
				if (counterY < vlines - 1)
					counterY <= counterY + 1;
				else
					counterY <= 0;
			end
		end
	end

	// Génération des signaux de synchronisations (logique négative)
	assign hsync = ((counterX >= hpixels - hbp - hpulse) && (counterX < hpixels - hbp)) ? 1'b0 : 1'b1;
	assign vsync = ((counterY >= vlines - vbp - vpulse) && (counterY < vlines - vbp)) ? 1'b0 : 1'b1;

	// inDisplayArea = 1 si le pixel en cours est dans la zone d'affichage, = 0 sinon
	assign inDisplayArea = 	(counterX < hpixels - hbp - hfp - hpulse)
										&&
									(counterY < vlines - vbp - vfp - vpulse);
	
	// Coordonnées écran du pixel en cours
	// (x, y) = (0, 0) à l'origine de la zone affichable
	assign x = counterX;
	assign y = counterY;
	
	// frame=1 au début de la 481è ligne, lorsque la zone d'affichage active a été balayée.
	assign frame = (counterX == 0) && (counterY == vlines - vpulse - vfp - vbp);
	
endmodule
	