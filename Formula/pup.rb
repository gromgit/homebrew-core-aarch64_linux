class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
  sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  license "MIT"
  head "https://github.com/EricChiang/pup.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pup"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0a93fbe0fde759b0bd67028999ec918288f43a30fa6c8395e045e247298b1ba3"
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/ericchiang/pup"
    dir.install buildpath.children

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    cd dir do
      system "gox", "-arch", arch, "-os", os, "./..."
      bin.install "pup_#{os}_#{arch}" => "pup"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
