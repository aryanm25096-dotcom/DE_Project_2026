# Git Step-by-Step Beginner Guide for Team T0125

Welcome! This guide is designed so you can easily clone our repository, work on your assigned tasks, and push your commits with zero errors or merge conflicts.

---

## 🚨 The Golden Rule
> **ONLY touch files inside your own assigned folder: `team_work/<your_name>/`!**  
> Never edit or delete files in other folders or at the root. Because everyone edits separate files, you will NEVER encounter merge conflicts.

---

## Step 1: Initial Setup (Do this once)

### 1.1 Accept your GitHub Collaborator Invite
Before doing anything on your laptop:
1. Open your college email or go to:  
   👉 `https://github.com/aryanm25096-dotcom/DE_Project_2026/invitations`
2. Click **Accept Invitation**.

### 1.2 Clone the Repository to your Laptop
Open Terminal (Mac/Linux) or Git Bash (Windows) and run:
```bash
git clone https://github.com/aryanm25096-dotcom/DE_Project_2026.git
cd DE_Project_2026
```

### 1.3 Configure your Name and Email
Ensure your git commits are credited to your GitHub username on the teacher's tracker:
```bash
# Example for Kanika:
git config user.name "Kanika Prajapati"
git config user.email "your_college_email@nst.rishihood.edu.in"
```
*(Replace with your actual name and email).*

---

## Step 2: Working on a Task

### 2.1 Always pull the latest code and make a new branch
Before starting work:
```bash
git checkout main
git pull origin main
git checkout -b <your_name>/<task_name>
```

**Examples:**
- Kanika: `git checkout -b kanika/discovery-queries`
- Dia: `git checkout -b dia/user-activity-queries`
- Ayesha: `git checkout -b ayesha/itinerary-queries`

### 2.2 Edit your starter file
Open the starter file in VS Code or your editor:
- Kanika: `DBMS-Instagram-Social-Media/team_work/kanika/`
- Dia: `DBMS-Instagram-Social-Media/team_work/dia/`
- Ayesha: `DBMS-Instagram-Social-Media/team_work/ayesha/`

Fill in the `TODO` sections according to your `TASKS.md` worksheet.

---

## Step 3: Testing your SQL (Quick Check)

To make sure your SQL has no syntax errors before committing:
```bash
# Test on your local PostgreSQL database:
psql -d tripsketch_db -f DBMS-Instagram-Social-Media/team_work/<your_name>/<file_name>.sql
```

---

## Step 4: Staging, Committing & Pushing

### 4.1 Stage your file
```bash
git add DBMS-Instagram-Social-Media/team_work/<your_name>/<file_name>.sql
```

### 4.2 Commit with the Standard Message Format
Format: `[CP<number>][<member_name>] <short description>`

**Examples:**
- `git commit -m "[CP2][kanika] add discovery queries"`
- `git commit -m "[CP2][dia] add user activity queries"`
- `git commit -m "[CP2][ayesha] add itinerary scheduling queries"`

### 4.3 Pull with Rebase & Push
```bash
# Ensure you are on top of latest main:
git pull --rebase origin main

# Push your branch to GitHub:
git push -u origin <your_name>/<task_name>
```

Once pushed, notify Aryan in our WhatsApp group chat so he can review and merge your branch into `main`!

---

## ❓ What to do if you encounter a conflict or error?
1. **Never panic or force push (`--force`).**
2. If `git pull --rebase` complains about changes:
   ```bash
   git status
   ```
3. If you accidentally edited a file outside your folder, undo it:
   ```bash
   git restore <file_name>
   ```
4. Drop a message to Aryan on WhatsApp and he will assist you immediately.
