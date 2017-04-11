package io.github.dagezi.vectortest;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.VectorDrawable;
import android.os.Build;
import android.support.graphics.drawable.VectorDrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.content.res.AppCompatResources;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private DrawableResourcesAdaptor adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        adapter = new DrawableResourcesAdaptor();

        RecyclerView listView = (RecyclerView) findViewById(R.id.imagesList);
        listView.setAdapter(adapter);
        listView.setLayoutManager(new LinearLayoutManager(this));
        DividerItemDecoration dividerItemDecoration =
                new DividerItemDecoration(this, DividerItemDecoration.VERTICAL);
        listView.addItemDecoration(dividerItemDecoration);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.activity_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.toggle_background:
                adapter.toggleImageBackground();
                return true;
            case R.id.toggle_only_orig:
                // TODO:
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private final R.drawable drawableResources = new R.drawable();

        private TextView nameView;
        private ImageView imageView;

        public ViewHolder(View itemView) {
            super(itemView);

            nameView = (TextView) itemView.findViewById(R.id.name);
            imageView = (ImageView) itemView.findViewById(R.id.image);
        }

        public void populate(Field field, boolean dark) {
            nameView.setText(field.getName());

            try {
                int resourceId = field.getInt(drawableResources);
                imageView.setImageResource(resourceId);
                imageView.setVisibility(View.VISIBLE);
                imageView.setBackgroundColor(dark ? Color.DKGRAY : Color.WHITE);
            } catch (Exception e) {
                imageView.setVisibility(View.GONE);
                e.printStackTrace();
            }
        }
    }

    private class DrawableResourcesAdaptor extends RecyclerView.Adapter<ViewHolder> {
        private final List<Field> fields = new ArrayList<>();
        private boolean darkBackground = false;

        public DrawableResourcesAdaptor() {
             R.drawable drawableResources = new R.drawable();

             for (Field f : R.drawable.class.getDeclaredFields()) {
                 try {
                     int resourceId = 0;
                     resourceId = f.getInt(drawableResources);
                     Drawable drawable = AppCompatResources.getDrawable(MainActivity.this, resourceId);
                     if (drawable instanceof VectorDrawableCompat ||
                             Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP &&
                                     drawable instanceof VectorDrawable) {
                         fields.add(f);
                     }
                 } catch (Exception e) {
                     e.printStackTrace();
                 }
             }
        }

        @Override
        public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater.from(MainActivity.this)
                    .inflate(R.layout.listitem_drawables, parent, false);
            return new ViewHolder(view);
        }

        @Override
        public void onBindViewHolder(ViewHolder holder, int position) {
            holder.populate(fields.get(position), darkBackground);
        }

        @Override
        public int getItemCount() {
            return fields.size();
        }

        public void toggleImageBackground() {
            darkBackground = !darkBackground;
            notifyDataSetChanged();
        }
    }
}
