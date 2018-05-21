%define theme sailfish-default

Name:       jolla-settings-powersave

BuildArch: noarch

Summary:    Settings plugin for battery powersave management
Version:    0.2.3
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
mkdir -p %{buildroot}%{_datadir}/jolla-settings/pages/powersave
cp -r settings/*.qml %{buildroot}%{_datadir}/jolla-settings/pages/powersave
mkdir -p %{buildroot}%{_datadir}/themes/%{theme}/meegotouch/z{1.0,1.25,1.5,1.5-large,1.75,2.0}/icons
cp -r icons/z* %{buildroot}%{_datadir}/themes/%{theme}/meegotouch
mkdir -p %{buildroot}%{_datadir}/jolla-settings/entries
cp -r settings/*.json %{buildroot}%{_datadir}/jolla-settings/entries
mkdir -p %{buildroot}%{_datadir}/translations
cp -r translations/settings-powersave-*.qm %{buildroot}%{_datadir}/translations

%files
%defattr(-,root,root,-)
%{_datadir}/jolla-settings/entries/*.json
%{_datadir}/jolla-settings/pages/powersave/*.qml
%{_datadir}/translations/*.qm
%{_datadir}/themes/%{theme}/meegotouch/z1.0/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.25/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.5/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.5-large/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.75/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z2.0/icons/*.png