pipeline {
    agent any

    stages {
        // Stage 1: Checkout code from the correct branch
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']], // Replace 'main' with your branch (e.g., 'master')
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/Asikmusta/cursor.git']]
                ])
            }
        }

        // Stage 2: Build Docker image in OpenShift
        stage('Build') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.startBuild("cursor-app", "--from-dir=.")
                    }
                }
            }
        }

        // Stage 3: Deploy to OpenShift
        stage('Deploy') {
            steps {
                script {
                    openshift.withCluster() {
                        if (!openshift.selector("dc", "cursor-app").exists()) {
                            openshift.newApp("cursor-app", "--name=cursor-app")
                        }
                        def dc = openshift.selector("dc", "cursor-app")
                        dc.rollout().latest()
                    }
                }
            }
        }

        // Stage 4: Expose Route (if not exists)
        stage('Expose Route') {
            steps {
                script {
                    openshift.withCluster() {
                        if (!openshift.selector("route", "cursor-app").exists()) {
                            openshift.expose("svc/cursor-app")
                        }
                    }
                }
            }
        }
    }
}
