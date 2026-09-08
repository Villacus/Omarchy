import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.villacus.automode"

  readonly property var autoService: bar && bar.shell ? bar.shell.serviceFor("io.github.villacus.automode") : null
  readonly property bool sessionActive: autoService ? autoService.sessionActive === true : false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""
    active: root.sessionActive
    tooltipText: root.sessionActive
      ? "Automatic Game Mode — active (Steam game running, desktop optimized)"
      : "Automatic Game Mode — idle (waiting for a Steam game)"
  }
}
