class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.1.2.tar.gz"
  sha256 "9abd6449d3cfac6dd0658160952797502da8aceda754fbbb7c520296d82d06dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "db332d7619c0fc800cee3e70b5b934c96d1717d17c32c50e9f908da1fb2da21f" => :catalina
    sha256 "24b9fb93b3e21a8f49e90980c2654ab69b594559b83fbb3966692019d79d3e0a" => :mojave
    sha256 "a4541a2e78f8a21bcd90936f6b6248454c0fdafa380dfd089b44559f0933d633" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
