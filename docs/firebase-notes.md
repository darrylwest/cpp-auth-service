# Auth Service with Firebase

A C++23 backend auth service developed with GCC-14.2.0 and Clang-17 on macOS ARM, targeting Ubuntu 24.10, and using CMake 3.30.0.

It's smart that you've got the Firebase C++ SDK in your vendor folder and are keeping it out of your Git repo. That's a great approach for managing dependencies!

Let's break down your two questions:

## 1) Getting API Keys for Your C++ Backend Service

When you're talking about a backend service interacting with Firebase, you're not usually looking for traditional "API keys" in the sense of a public string you'd embed in a mobile app. Instead, for secure server-side access to Firebase services (like Firebase Authentication, Cloud Firestore, Realtime Database, etc.), Firebase uses Service Accounts.

Think of a Service Account as a special kind of Google account that represents your server or backend application rather than an end-user. It has its own credentials that you use to authenticate and authorize requests to Firebase and other Google Cloud services.

Here's how you get one and why it's super important for your C++ backend:

### Generate a Service Account Key:
- Head over to your Firebase Console (you're already there, in Project overview, which is perfect!).
- Navigate to Project settings (the gear icon) and then select the Service accounts tab.
- You'll see a section for the "Firebase Admin SDK." This is exactly what you need for server-side interactions.
- Click on the "Generate new private key" button.
- A JSON file will be downloaded to your computer. This file contains all the necessary credentials (including a private key) for your service account.

**Crucial Security Warning:** This JSON file grants administrative access to your Firebase project. Treat it with the utmost care! Never ever check this file into your source code repository (like GitHub)! It's like the master key to your Firebase castle.

### Using the Service Account Key in Your C++ Backend:
The Firebase C++ SDK (specifically the Admin SDK components) will have methods to initialize it using these credentials. You'll typically provide the path to this JSON file in your application's configuration or load it directly.

### Best Practice for Deployment:
- **Environment Variables:** In production, a common and secure way is to store the content of this JSON file (or its path) in an environment variable on your server. Your C++ application can then read this environment variable at startup.
- **Secure Secrets Management:** For more complex deployments, consider using a dedicated secrets management service (like Google Cloud Secret Manager, HashiCorp Vault, or similar tools provided by your deployment environment) to store and retrieve these credentials securely.

So, when you say "API keys," for your C++ backend, think "Service Account JSON file." It's the secure handshake between your server and Firebase.

## 2) Getting the SDK URL for Your GitHub Actions Workflow CI

This is a great question, especially with C++ where dependencies can be a bit more involved than just a simple npm install or pip install.

Since you've chosen to have the SDK in your vendor folder, you likely have a specific way you're acquiring and building it. For a GitHub Actions CI pipeline, the "SDK URL" isn't a single download link like a CDN for a web library. Instead, it refers to the source of the SDK that your CI pipeline will need to either fetch or confirm is available.

The Firebase C++ SDK is open source and hosted on GitHub. The primary "URL" for the source code is:
https://github.com/firebase/firebase-cpp-sdk

Here are a few ways your GitHub Actions workflow could handle getting the SDK, depending on your current setup:

### If vendor is a git submodule:
If your vendor folder is actually a Git submodule pointing to the firebase-cpp-sdk repository, your CI workflow simply needs to ensure the submodules are cloned:

```yaml
steps:
  - uses: actions/checkout@v4
    with:
      submodules: 'recursive' # This will pull down your vendor submodule
```

### If vendor is manually populated or part of a larger build script:
If you're manually populating that vendor folder, or if your CMake build script fetches it, your CI workflow needs to replicate that process. You could add steps to:

#### Clone the repository:
```yaml
steps:
  - uses: actions/checkout@v4
  - name: Clone Firebase C++ SDK
    run: git clone https://github.com/firebase/firebase-cpp-sdk vendor/firebase-cpp

###### dpw | 2025.07.04 | 81Oh3xOKosND
