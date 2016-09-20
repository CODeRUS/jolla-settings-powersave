Name:       jolla-settings-powersave

BuildArch: noarch

Summary:    Settings plugin for battery powersave management
Version:    0.2.0
Release:    1
Group:      Qt/Qt
License:    TODO
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfish-version >= 2.0.1

%description
Battery powersave management settings plugin for the settings application


%prep
%setup -q -n %{name}-%{version}

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/jolla-settings/pages/powersave
cp -r settings/*.qml %{buildroot}/usr/share/jolla-settings/pages/powersave
cp -r icons/*.png %{buildroot}/usr/share/jolla-settings/pages/powersave
mkdir -p %{buildroot}/usr/share/jolla-settings/entries
cp -r settings/*.json %{buildroot}/usr/share/jolla-settings/entries

%files
%defattr(-,root,root,-)
%{_datadir}/jolla-settings/entries
%{_datadir}/jolla-settings/pages