class GoJsonnet < Formula
  desc "Go implemention of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.16.0.tar.gz"
  sha256 "8ca930c892d34a119c1970431d159000321fe323734f06a1253bd78fc3625b84"
  head "https://github.com/google/go-jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb17871662de6fcd37242ec9a60782b50840ed5bcfdef15d2051e7d85f58d64e" => :catalina
    sha256 "c1a8a6dd1935906504fcd72b60cd6291efaea0be467002192a6fbbf9dc0c2f5d" => :mojave
    sha256 "79e3dd913f59a061ae00bc98dd119791641395b730ebc233b26b583deb4a186a" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "jsonnet", :because => "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
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
