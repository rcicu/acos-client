pipeline {
    agent {
        node { label 'nwp_slave' }
    }
    environment {
        ARTIFACTORY_CREDS = credentials('abnetworking_service_pwd')
    }
    stages {
        stage('Docker') {
            agent {
                dockerfile {
                    reuseNode true
                }
            }
            stages {
                stage('Unit Tests and Other Checks by tox') {
                    steps {
                        sh 'sudo tox -e py38 -e pep8'  // Running only py36 and pep8 environment
                    }
                }
                stage('Build') {
                    steps {
                        sh 'python3 setup.py sdist bdist_wheel'
                    }
                }
                stage('Artifactory') {
                    when { branch 'master' }
                    steps {
                        sh 'twine upload --repository-url https://artifactory.viasat.com/artifactory/api/pypi/pypi-local-viasat dist/* -u ${ARTIFACTORY_CREDS_USR} -p ${ARTIFACTORY_CREDS_PSW}'
                    }
                }
            }
        }
    }
}
