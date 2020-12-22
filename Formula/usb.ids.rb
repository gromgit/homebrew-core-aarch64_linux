class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2020.08.26.orig.tar.xz"
  sha256 "de972f2cde2b681f3350273c4cae9985364c1acd99d774bdd82ca7e7408574d6"
  license any_of: ["GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/usb.ids/"
    regex(/href=.*?usb\.ids[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "02a17ca9f1852d442ac0b6b41591b547cffb9a104a5466d9e12fb18535b91fcd" => :big_sur
    sha256 "c4dabe62b2a771db0469b82e90c716271d858b8cee1f9e269ee8ee849b551485" => :arm64_big_sur
    sha256 "2994769226c7815ef5eee9ba27f729005fd993341dfbca50f413139ef411ac5c" => :catalina
    sha256 "8b29c5873a395b8bdff9219dcfafb13d05d7428c8f4d050cb776d332dd7aef1f" => :mojave
    sha256 "18a048550eae20c48c7af4cc0b93f1da748cae52417e364b1aedc154c27613d5" => :high_sierra
  end

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
