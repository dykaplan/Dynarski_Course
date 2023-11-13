/* 

Assignment: Problem Set 5
Course: EDU S598: Design and Analysis of Field Experiments in Education
Student: Dean Kaplan
Date: October 15, 2023

*/

clear all

global treatment_data = "/Users/dek811/Library/Mobile Documents/com~apple~CloudDocs/Documents/S598/pset 5/mindspark_treatment"

global figure_data = "/Users/dek811/Library/Mobile Documents/com~apple~CloudDocs/Documents/S598/pset 5/mindspark_figure"

global out_path = "/Users/dek811/Library/Mobile Documents/com~apple~CloudDocs/Documents/S598/pset 5/"

//load data
use "$treatment_data"

//Question 2
//replacting table 2

//run model one, vanilla treatment effect controling for baseline for math
reg m_theta_mle2 treat m_theta_mle1  ,r
return list
matrix list r(table)
eststo math_1, title("Math (1)") 
//run model two, vanilla treatment effect controling for baseline for hindi
reg h_theta_mle2 treat h_theta_mle1 ,r
eststo hindi_2, title("Hindi (2)") 

//model 3: add randomization bin fixed effects for math model
xtreg m_theta_mle2 treat m_theta_mle1 , fe i(strata) vce(robust)
eststo math_3, title("Math (3)") 
//model 4: add randomization bin fixed effects for hindi model
xtreg h_theta_mle2 treat h_theta_mle1 , fe i(strata) vce(robust)
eststo hindi_4, title("Hindi (4)") 

//Output with some formatting
esttab math_1 hindi_2 math_3 hindi_4 using "/Users/dek811/Library/Mobile Documents/com~apple~CloudDocs/Documents/S598/pset 5/model_1.tex",  label cells(b(fmt(%9.3f)) se (par(( )))) nonumbers collabels(none) eqlabels(none) noabbrev nobaselevels mgroups("\qquad Standardized IRT scores (endline)") mtitle("Math \newline (1)" "Hindi (2)" "Math (3)" "Hindi (4)") stats(N r2, fmt(%9.0g %9.3f %9.3f ) labels("Observations"  "R$^{2}$")) substitute("\_" "_") tex replace 


//Question 3, replicating Figure 2
//load data
use "$figure_data",clear

//cibar for math
cibar m_theta_mle, over(treat round) barcol(gs12 dknavy) graphopts(ylabel(, nogrid) graphregion(color(white)))

graph save Panel_A_rough.gph, replace

//cibar for hindi
cibar h_theta_mle, over(treat round) barcol(gs12 dknavy) graphopts(ylabel(, nogrid) graphregion(color(white))) 

graph save Panel_B_rough.gph, replace

//A note: The reason I outputted a rough version of these first is because the  graphopts argument for cibar simply doesnt work. This is confusing because the helpfile includes multiple instances of this argument. I therefore needed to make aesthetic edits in stata's Graph editor for final versions. 

//combine plots.
grc1leg Panel_A.gph Panel_B.gph,  ycommon  legendfrom(Panel_A.gph) 

graph save combined.gph, replace

graph export combined.png, replace width(1600) height(1000)


