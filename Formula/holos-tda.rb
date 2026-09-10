class HolosTda < Formula
  desc "Vietoris-Rips persistence and checked degree-Rips modules"
  homepage "https://github.com/t0rsion/holos"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "e8bb59661c9cf81e0f150ecf692b4dc962c29b4899f20d4aa004f142e00a551d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "bea6135c40f7706f14ec42093a5e71dd9256be6ffd77db05a21318e8e1d3c863"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "48c3848a147db4de6dc07913144ba4e068d056ddccf0df7dc51d69681063127c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a10ac11a7ac1e1624617594ebfc678f2defa57228a539bf749d7a5759eec5284"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
