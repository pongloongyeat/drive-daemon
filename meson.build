project(
    'com.github.pongloongyeat.drive-daemon',
    'vala',
    'c'
)

i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

executable(
    meson.project_name(),
    'src/Application.vala',
    dependencies: [
        dependency('gio-2.0'),
        dependency('glib-2.0'),
    ],
    install: true
)

subdir('data')
