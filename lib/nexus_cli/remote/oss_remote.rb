module NexusCli
  # @author Kyle Allan <kallan@riotgames.com>
  class OSSRemote < BaseRemote

    include ArtifactActions
    include GlobalSettingsActions
    include LoggingActions
    include RepositoryActions
    include CapabilityActions
    include UserActions
    include OssLdapSettingsActions
  end
end
