class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/2.0.0.tar.gz"
  sha256 "41474f185fd40602fb197e79df5cd4783ff57b92c1dfe2b8e2c4661af038ed9b"
  license "MIT"
  head "https://github.com/lapfelix/BluetoothConnector.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: ["11.0", :build]
  depends_on :macos

  # Fix build failure in Xcode 13. Remove with next release.
  patch do
    url "https://github.com/lapfelix/BluetoothConnector/commit/b628be43c95115488576e8b9360ca2f503d50f5a.patch?full_index=1"
    sha256 "996629003ec7a6c9487684c5e2c9cf7f093221f6e530ad0f25e59d41b5ab316d"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    shell_output("#{bin}/BluetoothConnector", 64)
    output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
    assert_equal "Not paired to device\n", output_fail
  end
end
