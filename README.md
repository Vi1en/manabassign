<img width="355" height="349" alt="image" src="https://github.com/user-attachments/assets/f8408f66-5df6-4ea1-a44c-b8376357d740" />

thats the final output got after running this file 

command for run

# Oracle Test (should return Mean: 1.000)
uv run harbor run --agent oracle --path harbor_tasks/word-count-task --job-name test-oracle

# NOP Test (should return Mean: 0.000)
uv run harbor run --agent nop --path harbor_tasks/word-count-task --job-name test-nop
