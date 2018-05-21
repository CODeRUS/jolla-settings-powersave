%define theme sailfish-default

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
mkdir -p %{buildroot}/usr/share/jolla-settings/entries
cp -r settings/*.json %{buildroot}/usr/share/jolla-settings/entries
mkdir -p %{buildroot}%{_datadir}/themes/%{theme}/meegotouch/z{1.0,1.25,1.5,1.5-large,1.75,2.0}/icons
cp -r icons/z* %{buildroot}%{_datadir}/themes/%{theme}/meegotouch

%files
%defattr(-,root,root,-)
%{_datadir}/jolla-settings/entries
%{_datadir}/themes/%{theme}/meegotouch/z1.0/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.25/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.5/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.5-large/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z1.75/icons/*.png
%{_datadir}/themes/%{theme}/meegotouch/z2.0/icons/*.png