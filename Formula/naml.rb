class Naml < Formula
  desc "Convert Kubernetes YAML to Golang"
  homepage "https://github.com/kris-nova/naml"
  url "https://github.com/kris-nova/naml/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0842633268b06be82db4dd10c3c938f756f613c44c15c2d935b933409da8c4bd"
  license "Apache-2.0"
  head "https://github.com/kris-nova/naml.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/naml"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a3b01f3f7acb31db28b6e7c039d30745f83bbbdf683ca4cd8a1ecf6d7bc3b508"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/kris-nova/naml.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    assert_match "Not Another Markup Language", shell_output("#{bin}/naml list")

    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Namespace
      metadata:
        name: brewtest
    EOS

    assert_match "Application autogenerated from NAML v#{version}",
      pipe_output("#{bin}/naml codify", (testpath/"service.yaml").read)
  end
end
