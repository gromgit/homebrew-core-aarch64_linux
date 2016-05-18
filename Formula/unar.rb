class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.10_src.zip"
  version "1.10"
  sha256 "866320ef9a4a21d593d314e229e38d928bbb31965b9e81ed347bfbf55fc2f25f"

  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  bottle do
    cellar :any
    sha256 "28e6bc35bad88f8c86e4575ba658d0cb1f56d6818860392c3229a438dbb51c3f" => :el_capitan
    sha256 "a9693c9b57367ed4d93ad7016d0b224892d7c301513aaf5105482c9379038e02" => :yosemite
    sha256 "b818b0efc49503cffa80ff7b9f4a22ffdd8d5c612044320dfd9893304d698256" => :mavericks
  end

  depends_on :xcode => :build

  def install
    # Build XADMaster.framework, unar and lsar
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-alltargets", "-configuration", "Release", "clean"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "XADMaster", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "unar", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "lsar", "SYMROOT=../", "-configuration", "Release"

    bin.install "./Release/unar", "./Release/lsar"

    lib.install "./Release/libXADMaster.a"
    frameworks.install "./Release/XADMaster.framework"
    (include/"libXADMaster").install_symlink Dir["#{frameworks}/XADMaster.framework/Headers/*"]

    cd "./Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert (testpath/"README.md").exist?
  end
end
