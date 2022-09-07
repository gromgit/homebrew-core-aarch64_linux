class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/SBJson/SBJson"
  url "https://github.com/SBJson/SBJson/archive/v5.0.3.tar.gz"
  sha256 "9a03f6643b42a82300f4aefcfb6baf46cc2c519f1bb7db3028f338d6d1c56f1b"
  license "BSD-3-Clause"
  head "https://github.com/SBJson/SBJson.git", branch: "trunk"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-project", "SBJson5.xcodeproj",
               "-target", "sbjson",
               "-configuration", "Release",
               "clean",
               "build",
               "SYMROOT=build"

    bin.install "build/Release/sbjson"
  end

  test do
    (testpath/"in.json").write <<~EOS
      [true,false,"string",42.001e3,[],{}]
    EOS

    (testpath/"unwrapped.json").write <<~EOS
      true
      false
      "string"
      42001
      []
      {}
    EOS

    assert_equal shell_output("cat unwrapped.json"),
                 shell_output("#{bin}/sbjson --unwrap-root in.json")
  end
end
