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

//Question 1
//replacting table 2


reg m_theta_mle2 treat m_theta_mle1  ,r
return list
matrix list r(table)
eststo math_1, title("Math (1)") 
reg h_theta_mle2 treat h_theta_mle1 ,r
eststo hindi_2, title("Hindi (2)") 

xtreg m_theta_mle2 treat m_theta_mle1 , fe i(strata) vce(robust)
eststo math_3, title("Math (3)") 
xtreg h_theta_mle2 treat h_theta_mle1 , fe i(strata) vce(robust)
eststo hindi_4, title("Hindi (4)") 

//run model to determine how much varience of outcome is explianed by demographic 
esttab math_1 hindi_2 math_3 hindi_4 using "/Users/dek811/Library/Mobile Documents/com~apple~CloudDocs/Documents/S598/pset 5/model_1.tex",  label cells(b(fmt(%9.3f)) se (par(( )))) nonumbers collabels(none) eqlabels(none) noabbrev nobaselevels mgroups("\qquad Standardized IRT scores (endline)") mtitle("Math \newline (1)" "Hindi (2)" "Math (3)" "Hindi (4)") stats(N r2, fmt(%9.0g %9.3f %9.3f ) labels("Observations"  "R$^{2}$")) substitute("\_" "_") tex replace 

//mtitle("Math {break}  (1)" "Hindi (2)" "Math (3)" "Hindi (4)")


//load data
use "$figure_data",clear
capture log close
//log using session,replace

set trace off

collapse (mean) mean =m_theta_mle (sd) sd =m_theta_mle, by(round treat)

gen ub = mean+1.96*sd

gen lb = mean-1.96*sd

graph twoway (bar mean treat if round==1, fintensity(inten100)color(gs12))(bar mean treat if round==2, fintensity(inten100)color(dknavy))  (rcap lb ub treat, lcolor(gs8)), xlabel(0 " " 1.5 "Baseline" 4.2 "Endline" 5.7 " " , noticks) legend(order(1 "Control" 2 "Treatment")) xtitle("") ytitle("mean of m_theta_mle") plotregion(margin(bargraph)) ylabel(, format(%9.3g)) ylabel(, nogrid) graphregion(color(white)) 


 
twoway (bar mean treat  if round==1, fintensity(inten100)color(gs12)) (bar  mean treat  if round==2, fintensity(inten100)color(dknavy)) 

(rcap ub lb mean, lcolor(gs8))
log close

, xlabel(0 " " 1.5 "Baseline" 4.170000076293945 "Endline" 5.670000076293945 " " , noticks) legend(order(1 "0" 2 "1")) xtitle("") ytitle("mean of m_theta_mle") plotregion(margin(bargraph)) ylabel(, format(%9.3g)) ylabel(, nogrid) graphregion(color(white)) 


version 13: 

cibar h_theta_mle, over(treat round) barcol(gs12 dknavy) graphopts(ylabel(, nogrid) graphregion(color(white)))

 graphopts(title("Price over 'foreign' over 'turn'") name(graph_1, replace)) 
 
log close
twoway bar m_theta_mle treat,  by( round)


graphopts(n

cibar m_theta_mle, over(treat round) barcol(gs12 dknavy) graphopts(ylabel(, nogrid) graphregion(color(white))) gr(name(graph_2, replace))

graphopts( name(graph_2, replace))
  
  , over(foreign turn) ciopts(lcolor(red)) graphopts(title("Price over 'foreign' over 'turn'") name(graph_1, replace))



cibar h_theta_mle, over(treat round) barcol(gs12 dknavy) graphopts(ylabel(, nogrid) graphregion(color(white)))  graphopts( name(b, replace))
  


grc1leg Panel_A.gph Panel_B.gph,  ycommon  legendfrom(Panel_A.gph) 

graph save combined.gph, replace

graph export combined.png, replace width(1600) height(1000)



frame copy default post
collapse (mean) mean_pre =m_theta_mle1 (sd) sd_pre=m_theta_mle1, by(treat)

cwf post

collapse (mean) mean_post =m_theta_mle2 (sd) sd_post=m_theta_mle2, by(treat)



twoway (bar m_theta_mle1 treatment, barwidth(0.4)) ///
       (rcap (m_theta_mle1 - 1.96 * std_error1) (m_theta_mle1 + 1.96 * std_error1) treatment, horizontal) ///
	   
	   
ciplot m_theta_mle m_theta_mle, by(treat) 

barcol("191 191 191" "32 44 80") graphopts(ylabel(, nogrid) graphregion(color(white)))

