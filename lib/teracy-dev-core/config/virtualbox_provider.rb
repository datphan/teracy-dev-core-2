require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/providers/
    class VirtualBoxProvider < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        providers_settings = settings['providers'] ||= []

        providers_settings.each do |provider_settings|
          @logger.debug("provider_settings: #{provider_settings}")
          case provider_settings['type']
          when "virtualbox"
            # TODO: check require_version
            configure_virtualbox(provider_settings, config)
          end
        end
      end

      private

      def configure_virtualbox(provider_settings, config)
        config.vm.provider "virtualbox" do |vb|
          vb.gui = true if provider_settings['gui'] == true

          general_settings_keys = ['name', 'groups', 'description', 'ostype', 'memory', 'vram', 'acpi',
            'ioapic', 'hardwareuuid', 'cpus', 'rtcuseutc', 'cpuhotplug', 'plugcpu', 'unplugcpu',
            'cpuexecutioncap', 'pae', 'longmode', 'synthcpu', 'hpet', 'hwvirtex', 'triplefaultreset',
            'nestedpaging', 'largepages', 'vtxvpid', 'vtxux', 'accelerate3d', 'bioslogofadein',
            'bioslogodisplaytime', 'bioslogoimagepath', 'biosbootmenu', 'snapshotfolder', 'firmware',
            'guestmemoryballoon', 'defaultfrontend'
          ]

          provider_settings.each do |key, val|
            if general_settings_keys.include?(key) and !provider_settings[key].nil?
              val = val.to_s.strip()
              if !val.empty?
                vb.customize ["modifyvm", :id, "--" + key, val]
              end
            end
          end
        end
      end
    end
  end

end
