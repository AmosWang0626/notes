# :basketball:Git学习笔记:biking_woman:

- git commit --amend（修改最后一次提交的描述）
- git reset --soft HEAD^（回退最后一次提交）
- git reset --soft HEAD~1（同上）
- git cherry-pick 15c83ebd52853b83b8eb31e2d4a99c63289f7（拉取别的分支指定代码）
- git diff --name-only 3b8eb31e2d4 31e2d4a99c632（找出不同commit有差异的文件）
- git rebase -i f363e5b（合并多次提交）
  - f363e5b 是要合并的提交之前那次提交
  - 修改要合并的 commit 前缀为 squash
    - `pick` 的意思是要会执行这个 commit
    - `squash` 的意思是这个 commit 会被合并到前一个commit
    - :wq
  - 最后指定commit message，:wq即可
- git 切换远程分支
  - git branch -a（查看所有分支，包括远程分支）
  - git checkout -b develop remotes/origin/develop（拉取远程分支）
  - git branch -d remotes/origin/develop（删除本地分支）
  - git branch（查看当前分支）
  - git log（查看提交记录）
- git 放弃本地修改，未add的:blonde_woman:
  - 语法：git checkout -- file
  - git checkout -- vue.config.js
- git add过的:blowfish:，恢复到未add区
  - git reset file

### 注意:1st_place_medal:

- git以功能为单位提交，便于往别的分支cherry-pick，毕竟很多业务在一个基础之上开发
