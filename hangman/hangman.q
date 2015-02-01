//a (toy) purely functional implementation of hangman
//ascii art
hangman:("";
	"---\n"; 
	" |\n |\n |\n---\n"; 
	"  ---\n |\n |\n |\n---\n";
	"  ---\n |  *\n |\n |\n---\n"; 
	"  ---\n |  *\n |  *\n |\n---\n";
	"  ---\n |  *\n | -*\n |\n---\n";
	"  ---\n |  *\n | -*-\n |\n---\n";
	"  ---\n |  *\n | -*-\n | /\n---\n";
	"  ---\n |  *\n | -*-\n | / \\\n---\n");
if[not `dictionary.txt in `$system "ls"; system "wget http://www.math.sjsu.edu/~foster/dictionary.txt"]; //download if not available already
words:read0 `:dictionary.txt 				
system "S ",string mod[;128] `int$.z.T //set a random seed
randomWord:{first 1?words}							
initState:{`hangix`guessed`partial`full!(0;"";(count w)#"*";w:randomWord[])}			
hasWon:{x[`partial]~x`full}														
hasLost:{(count hangman)=1+x`hangix}												
displayWord:{1 p,(w,"\n",count[(p:"Guess: "),w:x`partial]#" -"),"\n";}
displayHangman:{1 hangman x`hangix;}
displayState:{displayWord x; 1"\n\n"; displayHangman x;}
prompt:{show "Please provide a letter";first trim read0 0}
nextMove:{
	g:prompt/[{not first x in .Q.a};""];				    	//prompt until letter
	1 ("already guessed\n";"") isnew:not g in x`guessed; 		//warn about repeat guesses
	x[`partial]:@[x`partial; w:where g=x`full;:;g]; 			//fill in guessed letter
	x[`hangix]+:isnew*0=count w; 								//only penalize new and no hits
	x[`guessed],:isnew#g; 										//append if new guess
	displayState x; 											//display partially guessed and hangman
	x															//return new state
	}
start:{show "Would you like to play? [yes/no]";$["yes"~trim read0 0;play[]; end[]]}
end:{show "Bye bye";exit 0}
play:{s:nextMove/[{not (hasLost x)|hasWon x};initState[]]; $[hasWon s;show "Well Done!";show "Sorry, Answer: ",s`full]; start[]}
start[] //off we go...


