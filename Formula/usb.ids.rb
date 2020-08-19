class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2020.06.22.orig.tar.xz"
  sha256 "d55befb3b8bdb5db799fb8894c4e27ef909b2975c062fa6437297902213456a7"
  license ["GPL-2.0-or-later", "BSD-3-Clause"]

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
