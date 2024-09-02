class Alerter < Formula
  desc "Send User Alert Notification on macOS from the command-line"
  homepage "https://github.com/vjeantet/alerter"
  url "https://github.com/vjeantet/alerter/archive/refs/tags/004.tar.gz"
  sha256 "c4c16735e1a57ce04a5acfa762bd44ab8ef10884308725ab886b984b1de17bfe"
  license "MIT"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
                "-project", "alerter.xcodeproj",
                "-target", "alerter",
                "-configuration", "Release",
                "SYMROOT=build",
                "CODE_SIGN_IDENTITY=",
                "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/alerter"
  end

  test do
    system "alerter", "-timeout", "1", "-title", "Alerter Test", "-message", "test"
  end
end
