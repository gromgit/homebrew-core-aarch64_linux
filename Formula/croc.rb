class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.4.tar.gz"
  sha256 "6a7d304f06c6824c9648a588a5c6b9f7366d87a442dc536e810a078a4441c9dd"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "039652baeb41b1ea5816bb37bc4b89dd0c3cd98718b62493e522ddb559ee29a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "9182d66978027a376a0e32422b26e261e9283114d4f6afc78b4ca1c76d2c2a6c"
    sha256 cellar: :any_skip_relocation, catalina:      "f708b578664fa36e2d6f7e81f01ae6e882a0420a616be4fba056cf896ba7527f"
    sha256 cellar: :any_skip_relocation, mojave:        "eee107708c5a0bf821ed8608ea41a467ed892b0cd933fd7581c4389d0c8974e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
