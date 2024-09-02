class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.8.tar.gz"
  sha256 "04e9bacf5a73cddea9455f591700f452d2465001ccc0c8e6f37d27b8b376b6e0"
  license "MIT"
  head "https://github.com/cortesi/modd.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/modd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "740efae6a5cba0175a4588a2605b04cf30044fc0e6ecf9a728b264eb43e0e4bf"
  end

  # https://github.com/cortesi/modd/issues/96
  deprecate! date: "2021-08-27", because: :unmaintained

  depends_on "go@1.16" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/cortesi/modd").install buildpath.children
    cd "src/github.com/cortesi/modd" do
      system "go", "build", *std_go_args, "./cmd/modd"
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/modd")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Error reading config file ./modd.conf", io.read
  end
end
