document.addEventListener('DOMContentLoaded', () => {
    const floater = document.querySelector('._centerFloater_pb4js_70');
    const progressBar = document.querySelector('._progressBarForeground_pb4js_125');
    const fish = document.querySelector('._centerFish_pb4js_82');
    const container = document.querySelector('._centerContainer_pb4js_58'); // The parent container
    let progress = 0;
    let playerSpeed = 0; // Speed added by the player (positive to move right, negative to move left)
    let playerInfluence = 35; // Influence of player input on floater movement
    let automaticSpeed = 7000; // Speed at which the floater moves automatically
    let direction = -1; // Direction of floater's automatic movement (1 for right, -1 for left)
    let directionChangeInterval = 5000; // Time in milliseconds before changing direction
    let lastDirectionChangeTime = 0;
    let lastTime = 0;
    let fishOutOfBoundsCount = 0; // Counter for fish completely out of floater attempts
    const maxAttempts = 5; // Number of attempts before game over
    const errorInterval = 1000; // Time in milliseconds to check for fish being out of bounds
    let gameActive = false; // Game status

    function moveFloater(time) {
        if (!gameActive) return; 

        if (!lastTime) lastTime = time;
        const deltaTime = (time - lastTime) / 1000;
        lastTime = time;

        let currentLeft = parseFloat(window.getComputedStyle(floater).left) || 0;
        let movement = automaticSpeed * direction * deltaTime; 
        if (direction == -1) {
            movement = (automaticSpeed * 3) * direction * deltaTime; 
        }
        currentLeft += movement; 

        currentLeft += playerSpeed * playerInfluence;

        const containerRect = container.getBoundingClientRect();
        const containerWidth = containerRect.width;
        const floaterWidth = floater.offsetWidth;

        if (currentLeft < 0) currentLeft = 0;
        if (currentLeft > containerWidth - floaterWidth) currentLeft = containerWidth - floaterWidth;

        
        floater.style.left = (currentLeft + 35) + 'px';
        const fishRect = fish.getBoundingClientRect();
        const floaterRect = floater.getBoundingClientRect();

        if (
            fishRect.left >= floaterRect.left &&
            fishRect.right <= floaterRect.right
        ) {
            progress += 0.1; // Increment progress
            if (progress > 100) {
                progress = 100;
                
                gameActive = false; 
                finishGame(true)
                return;
            }
        } else {
            progress -= 0.05; 
            if (progress < 0) progress = 0;
        }

        progressBar.style.width = progress + '%';

        // Change direction periodically
        const currentTime = Date.now();
        if (currentTime - lastDirectionChangeTime > directionChangeInterval) {
            direction *= -1; 
            lastDirectionChangeTime = currentTime; 
        }

        requestAnimationFrame(moveFloater);
    }

    function checkFishOutOfBounds() {
        if (!gameActive) return; 

        const fishRect = fish.getBoundingClientRect();
        const floaterRect = floater.getBoundingClientRect();

        if (
            fishRect.left >= floaterRect.right ||
            fishRect.right <= floaterRect.left
        ) {
            fishOutOfBoundsCount++;
            //console.log('Error: Fish is out of bounds');

            if (fishOutOfBoundsCount >= maxAttempts) {
                //console.log('Game Over');
                gameActive = false; 
                finishGame(false);
                return; 
            }
        }

        setTimeout(checkFishOutOfBounds, errorInterval);
    }

    function capitalizeFirstLetter(str) {
        if (typeof str !== 'string' || str.length === 0) return str; // Handle empty string or non-string input
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    function finishGame(success) {
        fetch(`https://${GetParentResourceName()}/minigameResult`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ success }),
        }).then(resp => resp.json()).then(resp => {
            if (resp.closeUI) {
                fishMinigame.style.display = 'none';
            }
        });
    }

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (data.type === 'startMinigame') {
            playerInfluence = data.playerInfluence || playerInfluence;
            automaticSpeed = data.automaticSpeed || automaticSpeed;
            directionChangeInterval = data.directionChangeInterval || directionChangeInterval;
            progress = 0;
            fishOutOfBoundsCount = 0;
            gameActive = true;
            fishMinigame.style.display = 'block';
            
            document.addEventListener('keydown', (event) => {
                if (event.key === 'q' || event.key === 'Q') {
                    playerSpeed = -5; 
                } else if (event.key === 'e' || event.key === 'E') {
                    playerSpeed = 5;
                }
            });
        
            document.addEventListener('keyup', (event) => {
                if (event.key === 'q' || event.key === 'Q' || event.key === 'e' || event.key === 'E') {
                    playerSpeed = 0;
                }
            });
        
            requestAnimationFrame(moveFloater);
            checkFishOutOfBounds();
            
        } else if (data.type === 'stopMinigame') {
            gameActive = false;
            fishMinigame.style.display = 'none';
        } else if (data.type === 'showLeaderboard') {
            $('#leaderboard').show();
            updateFishList(data.fishList);
        } else if (data.type === 'updateLeaderboard') {
            updateLeaderboard(data.leaderboard);
        }
    });

    function updateFishList(fishList) {
        let fishListContainer = $('._leftContainer_eysdk_101');
        fishListContainer.empty();

        if (fishList && fishList.length > 0) {
            fishList.forEach((fish, index) => {
                let activeClass = index === 0 ? '_active_eysdk_165' : '';
                let fishButton = `
                    <div class="_leftListButton_eysdk_155 ${activeClass}" onclick="selectFish('${fish}', this)">
                        <div class="_leftListButtonText_eysdk_171">${capitalizeFirstLetter(fish)}</div>
                    </div>
                `;
                fishListContainer.append(fishButton);
            });

            // Fetch the leaderboard for the first fish by default
            fetchLeaderboard(fishList[0]);
        } else {
            console.error("fishList is empty or not defined");
        }
    }

    window.selectFish = function(fishName, element) {
        $('._leftListButton_eysdk_155').removeClass('_active_eysdk_165');
        $(element).addClass('_active_eysdk_165');
        fetchLeaderboard(fishName);
    }

    // Function to fetch leaderboard data
    window.fetchLeaderboard = function(fishName) {
        $.post(`https://${GetParentResourceName()}/fetchLeaderboard`, JSON.stringify({ fishName: fishName }))
            .done(function() {
/*                 console.log("POST request successful"); */
            })
            .fail(function(jqXHR, textStatus, errorThrown) {
/*                 console.error("POST request failed:", textStatus, errorThrown); */
            });
    };

    document.addEventListener('keydown', function(event) {
        var keyPressed = event.key;
    
        if (document.querySelector('#leaderboard').style.display != 'none') {
            if (keyPressed === 'Escape') {
                $('#leaderboard').hide(); 
                $.post(`https://${GetParentResourceName()}/hideMenu`); 
            }
        }
    });

    function updateLeaderboard(leaderboard) {
        let leaderboardContainer = $('tbody');
        leaderboardContainer.empty();

        if (leaderboard.length > 0) {
            leaderboard.forEach((entry, index) => {

                let fishLength = parseFloat(entry.fish_length);
                if (isNaN(fishLength)) fishLength = 0; 

                let fishLengthFormatted = fishLength.toFixed(2);

                let positionClass = index < 3 ? `__${index+1}_eysdk_248` : '';
                let row = `
                    <tr class="${index === leaderboard.length - 1 ? '_lastRow_eysdk_286' : ''}">
                        <td class="_position_eysdk_243 ${positionClass}">#${index+1}</td>
                        <td class="_length_eysdk_261">
                            <span class="_lengthText_eysdk_268">${Math.floor(fishLength)}</span>
                            <span class="_lengthDecimals_eysdk_264">.${fishLengthFormatted.split('.')[1]}</span>"
                        </td>
                        <td class="_name_eysdk_274">${entry.player_name || 'Unknown'}</td>
                        <td class="_timestamp_eysdk_280">${entry.caught_at || 'N/A'}</td>
                    </tr>
                `;
                leaderboardContainer.append(row);
            });
        } else {
            leaderboardContainer.append('<tr><td colspan="4">No data available</td></tr>');
        }
    }

    function demoStart()
    {
        progress = 0;
        fishOutOfBoundsCount = 0;
        gameActive = true;
        fishMinigame.style.display = 'block';
        
        document.addEventListener('keydown', (event) => {
            if (event.key === 'q' || event.key === 'Q') {
                playerSpeed = -5; 
            } else if (event.key === 'e' || event.key === 'E') {
                playerSpeed = 5;
            }
        });
    
        document.addEventListener('keyup', (event) => {
            if (event.key === 'q' || event.key === 'Q' || event.key === 'e' || event.key === 'E') {
                playerSpeed = 0;
            }
        });
    
        requestAnimationFrame(moveFloater);
        checkFishOutOfBounds();
    }
    
});
