project(
    'com.github.bertgoens.cloudhop',
    ['vala', 'c'],
    version: '0.1.0'
)

gnome = import('gnome')

asresources = gnome.compile_resources(
    'as-resources', 'data/css.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Widgets/ModeSwitch.vala',
    asresources,
    dependencies: [
        dependency('glib-2.0'),
        dependency('granite', version: '>=0.5'),
        dependency('gtk+-3.0')
    ],
    install: true
)

#Install our .desktop file so the Applications Menu will see it
install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Install our .appdata.xml file so AppCenter will see it
install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

# Save app specific settings over multiple runs
meson.add_install_script('meson/post_install.py')

subdir('data')
