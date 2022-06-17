class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.18.0.tar.gz"
  sha256 "369af561550ba8cff5dd7dd08a771805a38d795da3285221012cf3a2933b363e"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/go-jsonnet"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7d563fb0175397a120d634bb1a42504d61e8e5450e29363e7d51aa806bae2cfb"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
    system "go", "build", "-o", bin/"jsonnet-lint", "./cmd/jsonnet-lint"
    system "go", "build", "-o", bin/"jsonnet-deps", "./cmd/jsonnet-deps"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
