class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "3d766dc1856d04a8fb6de9942a6220d754d0fa7eae635d5287e7b1cf794c4f45"
  license "LGPL-2.1-or-later"
  head "https://github.com/MacPaw/XADMaster.git"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "bac059a80b30bd4ab2290e31bff0e93f933ddb6631252d6e1fab50b8f3c1736d"
    sha256 cellar: :any, big_sur:       "7b7680e174418478cb59d65815d7fb0799888247013eee04fc1bd88c43d3d49e"
    sha256 cellar: :any, catalina:      "366fc5e1d3587148e089214a91cd23a96eae1b0aefebcd2e9813b1cc2f6593c2"
    sha256 cellar: :any, mojave:        "7bc711ae9affa86d2bc6b29df427dbc900afa6f18bcf13dc4fcf0518f0a50ffa"
    sha256 cellar: :any, high_sierra:   "311cdc91d8897b3ebe20ea6b9e62bb2e4bc4bc15c9d2f321567cd010031df78a"
  end

  depends_on xcode: :build

  resource "universal-detector" do
    url "https://github.com/MacPaw/universal-detector/archive/refs/tags/1.1.tar.gz"
    sha256 "8e8532111d0163628eb828a60d67b53133afad3f710b1967e69d3b8eee28a811"
  end

  def install
    resource("universal-detector").stage buildpath/"../UniversalDetector"

    # Link to libc++.dylib instead of libstdc++.6.dylib
    inreplace "XADMaster.xcodeproj/project.pbxproj", "libstdc++.6.dylib", "libc++.1.dylib"

    # Replace usage of __DATE__ to keep builds reproducible
    inreplace %w[lsar.m unar.m], "@__DATE__", "@\"#{time.strftime("%b %d %Y")}\""

    mkdir "build" do
      # Build XADMaster.framework, unar and lsar
      arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
      %w[XADMaster unar lsar].each do |target|
        xcodebuild "-target", target, "-project", "../XADMaster.xcodeproj",
                   "SYMROOT=#{buildpath/"build"}", "-configuration", "Release",
                   "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}", "ARCHS=#{arch}", "ONLY_ACTIVE_ARCH=YES"
      end

      bin.install "./Release/unar", "./Release/lsar"
      %w[UniversalDetector XADMaster].each do |framework|
        lib.install "./Release/lib#{framework}.a"
        frameworks.install "./Release/#{framework}.framework"
        (include/"lib#{framework}").install_symlink Dir["#{frameworks}/#{framework}.framework/Headers/*"]
      end
    end

    cd "Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_predicate testpath/"README.md", :exist?
  end
end
