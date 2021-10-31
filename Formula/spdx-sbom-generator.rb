class SpdxSbomGenerator < Formula
  desc "Support CI generation of SBOMs via golang tooling"
  homepage "https://github.com/spdx/spdx-sbom-generator"
  url "https://github.com/spdx/spdx-sbom-generator/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "7d088f136a53d1f608b1941362c568d78cc6279df9c1bdb3516de075cb7f10c3"
  license any_of: ["Apache-2.0", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03ef31f7f9fd2439ee32bdc9a79da1791307f205aa469cfcc30a60ac6b9be9a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce7f6258ee19eb11fed935a5fa39a462c0422d2370b2cec47adb504e46557739"
    sha256 cellar: :any_skip_relocation, catalina:      "8afc7ba8305df4755757c2bb7d57e38436ccab3b9186cfc40781b30f52426a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9dfe484c574f4e8163880fc7d7ee4208be46154adc694295598ffe4f1db074"
  end

  depends_on "go" => [:build, :test]

  def install
    target = if Hardware::CPU.arm?
      "build-mac-arm64"
    elsif OS.mac?
      "build-mac"
    else
      "build"
    end

    system "make", target

    bin.install "bin/spdx-sbom-generator"
  end

  test do
    system "go", "mod", "init", "example.com/tester"

    assert_equal "panic: runtime error: index out of range [0] with length 0",
                 shell_output("#{bin}/spdx-sbom-generator 2>&1", 2).split("\n")[3]
  end
end
