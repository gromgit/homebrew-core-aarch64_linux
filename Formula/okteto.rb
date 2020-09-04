class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.19.tar.gz"
  sha256 "079010fe72bab6ed6b1f7cbe90d870234e27dc4e20269c658e4fd656251ecb4c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4ad1a00ad51ec5701275373410b32965559306be2eae1c67bff473a8fe7c3eb" => :catalina
    sha256 "0daabb2374bc3131c2402778b3050369e683684bc918cc7009a4a55976db7fcc" => :mojave
    sha256 "43b4568c8542520f7904b7482993d426cc9016991b59d16e9d23aeb45eb0516e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /okteto
      sync:
      - .:/okteto
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
