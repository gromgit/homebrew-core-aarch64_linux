class Locateme < Formula
  desc "Find your location using Apple's geolocation services"
  homepage "https://iharder.sourceforge.io/current/macosx/locateme"
  url "https://downloads.sourceforge.net/project/iharder/locateme/LocateMe-v0.2.1.zip"
  sha256 "137016e6c1a847bbe756d8ed294b40f1d26c1cb08869940e30282e933e5aeecd"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/LocateMe[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  depends_on :macos

  def install
    system ENV.cc, "-framework", "Foundation", "-framework", "CoreLocation", "LocateMe.m", "-o", "LocateMe"
    bin.install "LocateMe"
    man1.install "LocateMe.1"
  end

  test do
    system "#{bin}/LocateMe", "-h"
  end
end
