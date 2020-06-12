class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.3.1.tar.gz"
  sha256 "24a88acf72f8af1692c024fe574dfa98d7814980970920083e3f159a7244150c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f91edb58ba2f7ccf2a4f008d372a25cb3a76e3bda28b98d1cbc0a52f3ba6fb7" => :catalina
    sha256 "9e7bff9525666a35b5f6297ad8646e111241ad9429736ddc7270f33b4a02c594" => :mojave
    sha256 "31273bf05b627315103b77951fa5fbd1a8750fea10c7355bab3d7aaf45fd8aef" => :high_sierra
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
