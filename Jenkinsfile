// Repository name use, must end with / or be '' for none
repository= 'area51/'

// image prefix
imagePrefix = 'node'

// The image version, master branch is latest in docker
version=BRANCH_NAME
if( version == 'master' ) {
  version = 'latest'
}

// The architectures to build, in format recognised by docker
architectures = [ 'amd64', 'arm64v8' ]

// The node versions to build
buildVersions = [ '8.9.4', '9.7.1' ]

// latestVersion is the latest stable LTS version
latestVersion = '8.9.4'

// Current version is the current stable non-LTS version
currentVersion = '9.7.1'

// The slave label based on architecture
def slaveId = {
  architecture -> switch( architecture ) {
    case 'amd64':
      return 'AMD64'
    case 'arm64v8':
      return 'ARM64'
    default:
      return 'amd64'
  }
}

// The docker image name
// architecture can be '' for multiarch images
def dockerImage = {
  architecture,  buildVersion -> repository + imagePrefix + ':' +
     buildVersion +
    ( architecture=='' ? '' : ( '-' + architecture ) ) +
    ( version=='latest' ? '' : ( '-' + version ) )
}

// The go arch
def goarch = {
  architecture -> switch( architecture ) {
    case 'amd64':
      return 'amd64'
    case 'arm32v6':
    case 'arm32v7':
      return 'arm'
    case 'arm64v8':
      return 'arm64'
    default:
      return architecture
  }
}

properties( [
  buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: '10')),
  disableConcurrentBuilds(),
  disableResume(),
  pipelineTriggers([
    upstream('/Public/Alpine/master'),
  ])
])

// Build the images for each architecture
def buildNode = {
  architecture, buildVersion -> node( slaveId( architecture ) ) {
    stage( "Prepare " + architecture ) {
      checkout scm
      sh 'docker pull alpine'
    }

    stage( 'Build ' + architecture ) {
      sh 'docker build' +
          ' -t ' + dockerImage( architecture,  buildVersion ) +
          ' --build-arg VERSION=' + buildVersion +
          ' --squash' +
          ' .'
    }

    stage( 'Publish ' + architecture ) {
      sh 'docker push ' + dockerImage( architecture,  buildVersion )
    }
  }
}

// Generate the multi-arch image
def buildMultiArch = {
  buildVersion, tag -> node( "AMD64" ) {
    stage( tag + ' MultiArch' ) {
      // The manifest to publish
      multiImage = dockerImage( '', tag )

      // Create/amend the manifest with our architectures
      manifests = architectures.collect { architecture -> dockerImage( architecture,  buildVersion ) }
      sh 'docker manifest create -a ' + multiImage + ' ' + manifests.join(' ')

      // For each architecture annotate them to be correct
      architectures.each {
        architecture -> sh 'docker manifest annotate' +
          ' --os linux' +
          ' --arch ' + goarch( architecture ) +
          ' ' + multiImage +
          ' ' + dockerImage( architecture,  buildVersion )
      }

      // Publish the manifest
      sh 'docker manifest push -p ' + multiImage
    }
  }
}

buildVersions.each {
  buildVersion ->
    stage( buildVersion ) {
      parallel(
        'amd64': {
          buildNode( 'amd64', buildVersion )
        },
        'arm64v8': {
          buildNode( 'arm64v8', buildVersion )
        }
      )
    }

    buildMultiArch( buildVersion, buildVersion )
}

// Now the latest (LTS) and current (non-LTS) images
buildMultiArch( latestVersion, 'latest' )
buildMultiArch( currentVersion, 'current' )
