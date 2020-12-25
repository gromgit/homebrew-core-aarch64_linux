class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.2.2.tar.gz"
  sha256 "b57379acf44a533443bed942e21ae8391ee057e3cfd684b47ba60401b3e53e03"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7ef3b0fd60acf4ba42e8f8d3d79ec8bcccdb76abd771aca8759dd1a61a293756" => :big_sur
    sha256 "a810fd9f57c8477203a680cdd717168172ecd9f1ea60dbde1a7becbcbb13cf40" => :catalina
    sha256 "455befa40adb01c41a565409871a0e56c4bc116aaa362281afdf681650d9b36b" => :mojave
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
