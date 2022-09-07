class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://sveinbjorn.org/files/software/platypus/platypus5.3.src.zip"
  sha256 "b5b707d4f664ab6f60eed545d49a7d38da7557ce8268cc4791886eee7b3ca571"
  license "BSD-3-Clause"
  head "https://github.com/sveinbjornt/Platypus.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: ["8.0", :build]
  depends_on :macos

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}/dst",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "CODE_SIGN_IDENTITY=", "CODE_SIGNING_REQUIRED=NO",
               "clean",
               "install"

    man1.install "CLT/man/platypus.1"
    bin.install "dst/platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
      pkgshare.install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  def caveats
    <<~EOS
      This formula only installs the command-line Platypus tool, not the GUI.

      The GUI can be downloaded from Platypus' website:
        https://sveinbjorn.org/platypus

      Alternatively, install with Homebrew Cask:
        brew install --cask platypus
    EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
