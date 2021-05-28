class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.29.1.tar.gz"
  sha256 "87eaa789569c9b126fe495e182e008ed85a64d394229cd7c806e87b4b17ed5c6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3bf6e1b4e7be4268c2d9a2e00294f52b21c46da8e06ebb57703d917fcc6334a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f390fa4f734bed44cd383657149c2472a8509fced4d2753a978858613ef8ff9b"
    sha256 cellar: :any_skip_relocation, catalina:      "0b7a0a0bf7156b578e360dabe477a71831e8735d54f6bdf68cb79c7e111204f4"
    sha256 cellar: :any_skip_relocation, mojave:        "18904713f7c110bcca8444d8d11174886dc5cee2bf60ccbdb94b021a5af19638"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
