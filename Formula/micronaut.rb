class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.3.4.tar.gz"
  sha256 "e6c9f0f30735f24c85901a49114e919cc0ed84731ce98c736dad738d7f7c7174"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "21cac04676103aaa93717f6df7e06446176c3ff10d896eaaeec2233c7debb06a"
    sha256 cellar: :any_skip_relocation, catalina: "4646ba77ac48215511bd9a60693ecb3126480849874b230cbcfc3f5848c772a9"
    sha256 cellar: :any_skip_relocation, mojave:   "5b64bf426e89a27f3c9392ade6af3606524fa2af91c4c9a519a7c044398faea5"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
