class OsxCpuTemp < Formula
  desc "Outputs current CPU temperature for OSX"
  homepage "https://github.com/lavoiesl/osx-cpu-temp"
  url "https://github.com/lavoiesl/osx-cpu-temp/archive/1.1.0.tar.gz"
  sha256 "94b90ce9a1c7a428855453408708a5557bfdb76fa45eef2b8ded4686a1558363"
  license "GPL-2.0"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  def install
    system "make"
    bin.install "osx-cpu-temp"
  end

  test do
    assert_match "°C", shell_output("#{bin}/osx-cpu-temp -C")
  end
end
