I was inspired by implementations of Wave Function Collapse for terrain generation, and wanted to make something similar. I've come across a straightforward and simple approach that works well at runtime. First, I create a sample environment by manually placing down tiles, then loop over all those tiles to get adjacency rules. For example, if I never put deep water next to a tree, they won't list each other as possible adjacent tiles. Then, when the player moves near the edge of the world, new tiles are "revealed" (generated) by following those constraints to get potential tiles, then randomly selecting one.

A wide variety of interesting environments are possible.

![capture 01](https://github.com/user-attachments/assets/b66cb9be-e56e-4c43-8b6d-c0c1b0121a2a)

![capture 02](https://github.com/user-attachments/assets/890da5c1-2806-437b-99ce-a9193199c5bb)
