Ext.define('RtConfigurator.view.configurator.dialogs.LoginDialog', {
    extend: 'Ext.form.Panel',
    floating: true,
    modal: true,
    title: 'Addresses',
    bodyPadding: 5,
    width: 350,

    requires: [
        'RtConfigurator.view.configurator.ConfiguratorPanel',
        'RtConfigurator.view.configurator.SettingsPanel'
    ],

    // Fields will be arranged vertically, stretched to full width
    layout: 'anchor',
    defaults: {
        anchor: '100%'
    },

    // The fields
    defaultType: 'textfield',
    items: [
        {
            fieldLabel: 'Server',
            name: 'server',
            allowBlank: false,
            value: 'localhost:4000'
        },
        {
            fieldLabel: 'Telemetry',
            name: 'telemetry',
            allowBlank: true,
            value: 'localhost:7681'
        }
    ],

    // Reset and Submit buttons
    buttons: [
        {
            text: 'Connect',
            formBind: true, //only enabled once the form is valid
            disabled: true,

            handler: function () {
                var form = this.up('form').getForm();

                var values = form.getFieldValues();

                //console.log(values.server);
                //console.log(values.telemetry);

                // Найдем хранилище и иницируем загрузку в него определения модулей
                var storeMetaModules = Ext.StoreMgr.lookup("MetamodulesStore");
                storeMetaModules.getProxy().setUrl( 'http://' + values.server + '/metamodules' );
                storeMetaModules.load();


                // Добавим вкладку конфигуратора в главный лайаут приложения
                var mainLayout = this.ownerCt.ownerCt.floatParent.items.items[0];
                mainLayout.add(new RtConfigurator.view.configurator.ConfiguratorPanel(
                    {
                        url_server: values.server,
                        url_telemetry: values.telemetry
                    }
                ));

                mainLayout.add(new RtConfigurator.view.configurator.SettingsPanel());

                this.up('form').close();
            }
        }
    ]
});

