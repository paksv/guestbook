#!/bin/bash

typeGuess=$1
if [[ -z ${typeGuess+x} ]]
then echo ""
else typeGuess=$RANDOM
fi 
fixFailGuess=$2
if [[ -z${fixFailGuess+x} ]]
then echo ""
else fixFailGuess=$RANDOM
fi

typeLimit=10
fixFailLimit=11

let "fixFailGuess %= $fixFailLimit"
let "typeGuess %= $typeLimit"

if [[ $typeGuess -lt 5 ]]
then type="java"
else 
	if [[ $typeGuess -lt 11 ]]
	then type="js"
	else type="system"
	fi
fi

echo "choise $fixFailGuess for $type ($typeGuess)"

git pull

if [[ $fixFailGuess -lt 5 ]]
then echo "failing a test..."
	if [[ $type = "java" ]]
	then 
		cat "../backend/src/test/java/guestbook/GuestBookEntryTest.java" | sed s:"// ##roboDevelopersTokenStart":"// ##roboDevelopersTokenStart\\
	@Test\\
	public void test$RANDOM() {\\
		throw new RuntimeException();\\
	}\\
":g > "../backend/src/test/java/guestbook/GuestBookEntryTest.java_"
		mv "../backend/src/test/java/guestbook/GuestBookEntryTest.java_" "../backend/src/test/java/guestbook/GuestBookEntryTest.java"
	fi
	if [[ $type = "js" ]]
	then 
		cat "../frontend/src/components/guestbook/guestbook.test.js" | sed s:"// ##roboDevelopersTokenStart":"// ##roboDevelopersTokenStart\\
  it('failing test $RANDOM', () => {\\
    shallowGuestbook().should.have.tagName('wat');\\
  });\\
":g > "../frontend/src/components/guestbook/guestbook.test.js_"
		mv "../frontend/src/components/guestbook/guestbook.test.js_" "../frontend/src/components/guestbook/guestbook.test.js"
	fi
	if [[ $type = "system" ]]
	then
		testSuffix=$RANDOM
		echo "echo \"##teamcity[testStart name='test$testSuffix']\"" >> "../systemTests/systemTests.sh"
		echo "echo \"##teamcity[testEnd name='test$testSuffix']\"" >> "../systemTests/systemTests.sh"
	fi
else echo "fixing all tests..."
	if [[ $type = "java" ]]
	then 
		cat "../backend/src/test/java/guestbook/GuestBookEntryTest.java" | sed ':a;N;$!ba;s/\/\/ ..roboDevelopersTokenStart\n.*\/\/ ..roboDevelopersTokenEnd\n/\/\/ ##roboDevelopersTokenStart\
\/\/ ##roboDevelopersTokenEnd\
/g' > "../backend/src/test/java/guestbook/GuestBookEntryTest.java_"
		mv "../backend/src/test/java/guestbook/GuestBookEntryTest.java_" "../backend/src/test/java/guestbook/GuestBookEntryTest.java"
	fi
	if [[ $type = "js" ]]
	then 
                cat "../frontend/src/components/guestbook/guestbook.test.js" | sed ':a;N;$!ba;s/\/\/ ..roboDevelopersTokenStart\n.*\/\/ ..roboDevelopersTokenEnd\n/\/\/ ##roboDevelopersTokenStart\
\/\/ ##roboDevelopersTokenEnd\
/g' > "../frontend/src/components/guestbook/guestbook.test.js_"
		mv "../frontend/src/components/guestbook/guestbook.test.js_" "../frontend/src/components/guestbook/guestbook.test.js"
	fi
	if [[ $type = "system" ]]
	then
		cat "../systemTests/systemTests.sh" | sed ':a;N;$!ba;s/..roboDevelopersToken.*/##roboDevelopersToken/g' > "../systemTests/systemTests.sh_"
		mv "../systemTests/systemTests.sh_" "../systemTests/systemTests.sh"
	fi
fi

git add "../backend/src/test/java/guestbook/GuestBookEntryTest.java"
git add "../frontend/src/components/guestbook/guestbook.test.js"
git add "../systemTests/systemTests.sh"
git ci -m"RoboDeveloper#$RANDOM in charge!"
git push
